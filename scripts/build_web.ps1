Param()
Write-Host 'Building Flutter web (release)...'
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Error 'Flutter CLI not found in PATH. Install Flutter and ensure `flutter` is available.'; exit 1
}

pushd "$PSScriptRoot/.."
try {
  flutter pub get
  flutter build web --release
  Write-Host 'Build complete. Output at: build\web'
} finally { popd }
