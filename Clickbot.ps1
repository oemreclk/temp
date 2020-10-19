#USAGE
#Detect MaxPageNumber/Wait time per page AND where to click (Coordinates)
#Run script and go to where want to click then wait 10 seconds

#Souce
#https://stackoverflow.com/questions/38225874/mouse-click-automation-with-powershell-or-other-non-external-software
#https://social.technet.microsoft.com/Forums/en-US/1f89491b-0c0d-48d0-874c-97ca96127a8e/script-using-windows-powershell-ise-to-move-mouse-and-control-keyboard?forum=winserverpowershell
#https://docs.microsoft.com/en-us/windows/desktop/api/winuser/nf-winuser-mouse_event

$MaxPageNumnber = 130
$WaitTime = 40 

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$signature=@'
[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)] 
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@

$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

###STEP 1### where to click Coordinates

#Get mouse/cursor pixel position on your screen by entering below command.
sleep 10
$X = [System.Windows.Forms.Cursor]::Position.X
$Y = [System.Windows.Forms.Cursor]::Position.Y
Write-Output "X: $X | Y: $Y"

###STEP 2###

#In above command you are simply getting cursor X & Y Position. Please note, you may have to perform this steps for more times to get the mouse pixels, as in where you want your mouse cursor to go and click.

#Once you have all your positions noted down where you wish to perform the mouse clicks, it's now time to set it up.
for($i=1; $i -le $MaxPageNumnber; $i++){
#$X = 3393
#$Y = 981

$X_current = [System.Windows.Forms.Cursor]::Position.X
$Y_current = [System.Windows.Forms.Cursor]::Position.Y

#Set coordinate where to want to click
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)

sleep -Seconds 01
$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);

#Move to current position
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X_current, $Y_current)
$SendMouseClick::mouse_event(0x00000001, 0, 0, 0, 0);
sleep -Seconds 01

sleep $WaitTime
Write-Host $i Page
}

