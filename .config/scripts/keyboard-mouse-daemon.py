#!/usr/bin/env python3

import asyncio
import os
import signal
import subprocess
import sys
from pathlib import Path

from evdev import InputDevice, ecodes, list_devices

RUNTIME_DIR = Path(os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}"))
STATE_DIR = RUNTIME_DIR / "keyboard-mouse"
ACTIVE_FILE = STATE_DIR / "active"

NORMAL_STEP = 8
FAST_STEP = 28
SLOW_STEP = 2
FRAME_DELAY = 0.012

pressed_keys: set[int] = set()
running = True


def find_keyboards() -> list[InputDevice]:
    keyboards: list[InputDevice] = []

    for path in list_devices():
        try:
            device = InputDevice(path)
            capabilities = device.capabilities()

            keys = capabilities.get(ecodes.EV_KEY, [])

            # Yön tuşlarını içeren klavyeleri seç.
            if (
                ecodes.KEY_LEFT in keys
                and ecodes.KEY_RIGHT in keys
                and ecodes.KEY_UP in keys
                and ecodes.KEY_DOWN in keys
            ):
                keyboards.append(device)

        except (PermissionError, OSError):
            continue

    return keyboards


def mouse_speed() -> int:
    shift_pressed = (
        ecodes.KEY_LEFTSHIFT in pressed_keys
        or ecodes.KEY_RIGHTSHIFT in pressed_keys
    )

    ctrl_pressed = (
        ecodes.KEY_LEFTCTRL in pressed_keys
        or ecodes.KEY_RIGHTCTRL in pressed_keys
    )

    if ctrl_pressed:
        return SLOW_STEP

    if shift_pressed:
        return FAST_STEP

    return NORMAL_STEP


def calculate_direction() -> tuple[int, int]:
    x = 0
    y = 0

    if ecodes.KEY_LEFT in pressed_keys:
        x -= 1

    if ecodes.KEY_RIGHT in pressed_keys:
        x += 1

    if ecodes.KEY_UP in pressed_keys:
        y -= 1

    if ecodes.KEY_DOWN in pressed_keys:
        y += 1

    return x, y


async def read_keyboard(device: InputDevice) -> None:
    global running

    try:
        async for event in device.async_read_loop():
            if not running:
                return

            if event.type != ecodes.EV_KEY:
                continue

            if event.value in (1, 2):
                # 1: basıldı, 2: otomatik tekrar
                pressed_keys.add(event.code)

            elif event.value == 0:
                # Tuş bırakıldı.
                pressed_keys.discard(event.code)

    except (OSError, asyncio.CancelledError):
        return


async def movement_loop() -> None:
    while running:
        if ACTIVE_FILE.exists():
            x, y = calculate_direction()

            if x != 0 or y != 0:
                step = mouse_speed()

                # Çapraz harekette iki ekseni aynı komutla gönder.
                move_x = x * step
                move_y = y * step

                subprocess.run(
                    [
                        "ydotool",
                        "mousemove",
                        "--",
                        str(move_x),
                        str(move_y),
                    ],
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    check=False,
                )
        else:
            # Mod kapandığında hiçbir tuş takılı kalmasın.
            pressed_keys.clear()

        await asyncio.sleep(FRAME_DELAY)


def stop_daemon(*_: object) -> None:
    global running
    running = False


async def main() -> int:
    STATE_DIR.mkdir(parents=True, exist_ok=True)

    keyboards = find_keyboards()

    if not keyboards:
        print(
            "Yön tuşlarını içeren erişilebilir bir klavye bulunamadı.",
            file=sys.stderr,
        )
        print(
            'Kullanıcının "input" grubunda olduğunu kontrol et.',
            file=sys.stderr,
        )
        return 1

    for device in keyboards:
        print(f"Keyboard: {device.path} — {device.name}")

    tasks = [
        asyncio.create_task(read_keyboard(device))
        for device in keyboards
    ]

    tasks.append(asyncio.create_task(movement_loop()))

    try:
        await asyncio.gather(*tasks)
    finally:
        for task in tasks:
            task.cancel()

    return 0


if __name__ == "__main__":
    signal.signal(signal.SIGINT, stop_daemon)
    signal.signal(signal.SIGTERM, stop_daemon)

    raise SystemExit(asyncio.run(main()))
