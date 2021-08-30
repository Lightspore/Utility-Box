# How to use
# 1. Open powershell
# 2. Copy all code and paste into powershell
# 3. run "Show-Window PID"

function Show-Window {
  param(
    [Parameter(Mandatory)]
    [int] $ProcessID
  )

  # Get the PID of the first instance of a process with the given name
  # that has a non-empty window title.
  # NOTE: If multiple instances have visible windows, it is undefined
  #       which one is returned.
  $hWnd = (Get-Process -ErrorAction Ignore -Id $ProcessID).Where({ $_.MainWindowTitle }, 'First').MainWindowHandle

  if (-not $hWnd) { Throw "No $ProcessID process with a non-empty window title found." }

  $type = Add-Type -PassThru -NameSpace Util -Name SetFgWin -MemberDefinition @'
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);    
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool IsIconic(IntPtr hWnd);    // Is the window minimized?
'@ 

  # Note: 
  #  * This can still fail, because the window could have bee closed since
  #    the title was obtained.
  #  * If the target window is currently minimized, it gets the *focus*, but its
  #    *not restored*.
  $null = $type::SetForegroundWindow($hWnd)
  # If the window is minimized, restore it.
  # Note: We don't call ShowWindow() *unconditionally*, because doing so would
  #       restore a currently *maximized* window instead of activating it in its current state.
  if ($type::IsIconic($hwnd)) {
    $type::ShowWindow($hwnd, 9) # SW_RESTORE
  }
}

