#This allows HyperV to create a virtual machine with multiple user input parameters below.
#The changeme comment should be used by the user to specify resources in their environment.

#Allow different values to be passed when running the script
param (
    [string]$action
)

# VM parameters
$vmName = "CustomAMXUbuntuVM"  #changeme
$vmPath = "D:\Virtual Machines\AMX_TEST" #changeme
$vhdPath = "$vmPath\$vmName.vhdx"
$image = "D:\OS\ubuntu-22.04-autoinstall.iso" #changeme
$vmswitch = "QLogic BCM5709C Gigabit Ethernet (NDIS VBD Client) #3 - Virtual Switch" #changeme
$cpu = 1 #changeme
$ram = 6GB #changeme
$vhdSize = 80GB #changeme

# Handle actions
if ($action -eq "create") {
    # Create VM
    Write-Output "Creating VM: $vmName"
    New-VM -Name $vmName -Path $vmPath
    Set-VM -Name $vmName -ProcessorCount $cpu -MemoryStartupBytes $ram
    New-VHD -Path $vhdPath -SizeBytes $vhdSize
    Add-VMHardDiskDrive -VMName $vmName -Path $vhdPath
    Set-VMDvdDrive -VMName $vmName -Path $image
    Connect-VMNetworkAdapter -VMName $vmName -SwitchName $vmswitch
    Start-VM -Name $vmName
    Write-Output "VM $vmName created and started successfully."

} elseif ($action -eq "destroy") {
    # Destroy VM
    Write-Output "Destroying VM: $vmName"
    if (Get-VM -Name $vmName -ErrorAction SilentlyContinue) {
        Stop-VM -Name $vmName -Force
        Remove-VM -Name $vmName -Force
        if (Test-Path -Path $vhdPath) {
            Remove-Item -Path $vhdPath -Force
        }
        Write-Output "VM $vmName and associated resources have been removed."
    } else {
        Write-Output "VM $vmName does not exist. Nothing to destroy."
    }

} else {
    Write-Output "Invalid action specified. Use 'create' or 'destroy'."
    exit 1
}