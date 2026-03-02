# Đặt JAVA_HOME cho phiên terminal hiện tại (để Gradle/Flutter build đúng JDK).
# Chạy: .\set-java-home.ps1
# Hoặc set vĩnh viễn: xem SETUP.md mục "JAVA_HOME".
$env:JAVA_HOME = "E:\_Compliers\JavaJDK\JavaJDK21"
Write-Host "JAVA_HOME = $env:JAVA_HOME"
& "$env:JAVA_HOME\bin\java.exe" -version
