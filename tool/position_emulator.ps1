# Positions the running Android emulator window on the left half of the primary display.
Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32Move {
    [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

$proc = Get-Process |
    Where-Object { $_.ProcessName -match 'emulator|qemu' -and $_.MainWindowHandle -ne 0 } |
    Select-Object -First 1

if (-not $proc) {
    Write-Output 'NO_EMULATOR_WINDOW'
    exit 1
}

$hwnd = $proc.MainWindowHandle
# SW_RESTORE in case the window is minimized.
[Win32Move]::ShowWindow($hwnd, 9) | Out-Null

$work = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$width = [int]($work.Width / 2)
$height = $work.Height

# SWP_NOZORDER (0x0004) keeps z-order, SWP_SHOWWINDOW (0x0040) ensures visibility.
[Win32Move]::SetWindowPos($hwnd, [IntPtr]::Zero, $work.X, $work.Y, $width, $height, 0x0004 -bor 0x0040) | Out-Null

Write-Output "MOVED '$($proc.MainWindowTitle)' to left half ($width x $height) of $($work.Width) x $($work.Height)"
