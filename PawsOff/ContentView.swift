import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var keyboardManager: KeyboardManager
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: keyboardManager.isLocked ? "keyboard.badge.ellipsis" : "keyboard")
                .font(.system(size: 64))
                .foregroundStyle(keyboardManager.isLocked ? .red : .green)
                .symbolEffect(.pulse, isActive: keyboardManager.isLocked)
            
            Text(keyboardManager.isLocked ? "Keyboard Locked" : "Keyboard Active")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(keyboardManager.isLocked ? .red : .primary)
            
            if !keyboardManager.hasAccessibilityPermission {
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                        Text("Accessibility Permission Required")
                            .fontWeight(.medium)
                    }
                    
                    Text("PawsOff needs Accessibility access to block keyboard input.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Open System Settings") {
                        keyboardManager.openAccessibilitySettings()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Check Permission") {
                        keyboardManager.checkAccessibilityPermission()
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.orange.opacity(0.1))
                        .stroke(.orange.opacity(0.3), lineWidth: 1)
                )
            }
            
            Button(action: {
                keyboardManager.toggleLock()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: keyboardManager.isLocked ? "lock.open.fill" : "lock.fill")
                        .font(.title2)
                    Text(keyboardManager.isLocked ? "Unlock Keyboard" : "Lock Keyboard")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(keyboardManager.isLocked ? Color.red : Color.green)
                )
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .shadow(color: (keyboardManager.isLocked ? Color.red : Color.green).opacity(0.4), radius: 8, y: 4)
            .disabled(!keyboardManager.hasAccessibilityPermission)
            .opacity(keyboardManager.hasAccessibilityPermission ? 1.0 : 0.5)
            
            Text(keyboardManager.isLocked
                 ? "Click the button above to re-enable your keyboard"
                 : "Lock your keyboard to clean it safely")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(32)
        .frame(width: 340, height: 420)
        .onAppear {
            keyboardManager.checkAccessibilityPermission()
        }
        .touchBar {
            Button(action: {
                keyboardManager.toggleLock()
            }) {
                Label(
                    keyboardManager.isLocked ? "Unlock" : "Lock",
                    systemImage: keyboardManager.isLocked ? "lock.open.fill" : "lock.fill"
                )
            }
            .touchBarItemPresence(.required("lockToggle"))
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(KeyboardManager())
}
