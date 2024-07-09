# Save this as hacked.ps1

# Add necessary assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$form = New-Object Windows.Forms.Form
$form.Text = "Alert"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'None' # Remove the form border
$form.BackColor = [System.Drawing.Color]::Black
$form.TopMost = $true

# Create a label to display the message
$label = New-Object Windows.Forms.Label
$label.Text = "YOU HAVE BEEN HACKED"
$label.ForeColor = [System.Drawing.Color]::Red
$label.Font = New-Object System.Drawing.Font("Arial", 20, [System.Drawing.FontStyle]::Bold)
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point((($form.ClientSize.Width - $label.PreferredWidth) / 2), (($form.ClientSize.Height - $label.PreferredHeight) / 2))
$form.Controls.Add($label)

# Function to create matrix effect
function Show-MatrixEffect {
    param (
        [Windows.Forms.Form]$form
    )
    
    $chars = @("0", "1", "X", "Y", "Z")
    $graphics = $form.CreateGraphics()
    $brush = New-Object Drawing.SolidBrush([System.Drawing.Color]::Green)
    $font = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)

    $width = $form.ClientSize.Width
    $height = $form.ClientSize.Height

    while ($true) {
        $x = Get-Random -Minimum 0 -Maximum $width
        $y = Get-Random -Minimum 0 -Maximum $height
        $char = $chars | Get-Random
        $graphics.DrawString($char, $font, $brush, $x, $y)
        Start-Sleep -Milliseconds 50
    }
}

# Run the matrix effect in a separate runspace
$runspace = [powershell]::Create().AddScript({
    param ($form)
    Show-MatrixEffect -form $form
}).AddArgument($form)
$runspace.Runspace.ThreadOptions = [System.Management.Automation.Runspaces.PSThreadOptions]::ReuseThread
$runspace.Runspace.ApartmentState = [System.Threading.ApartmentState]::STA
$runspace.Runspace.Open()
$runspace.BeginInvoke()

# Show the form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
