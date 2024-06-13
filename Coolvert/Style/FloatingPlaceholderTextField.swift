import SwiftUI

struct FloatingPlaceholderTextField: View {
    @Binding var text: String
    var placeholder: String
    @State private var isFocused: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background and border
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.color9, lineWidth: 0.4)
                .background(Color.color2)
                .cornerRadius(8)
            
            // Placeholder text

                Text(placeholder)
                .foregroundColor(isFocused || !text.isEmpty ? Color.color9 : .gray)
                    .background(Color.clear)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .offset(y: (isFocused || !text.isEmpty) ? -45 : 0)
                    .scaleEffect((isFocused || !text.isEmpty) ? 0.80 : 1.0, anchor: .leading)
                    .animation(.easeInOut(duration: 0.2), value: isFocused || !text.isEmpty)
            
            
            // Text field
                TextField("", text: $text, onEditingChanged: { editing in
                    withAnimation {
                        isFocused = editing
                    }
                })
                .padding()
                .background(Color.clear) // Define o fundo do TextField como transparente
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.horizontal, 8) // Garante o preenchimento para corresponder ao placeholder
            
            // Secure field (hidden by default)
            if !text.isEmpty && placeholder == "Senha" || !text.isEmpty && placeholder == "Confirme a Senha" {
                SecureField("", text: $text)
                    .padding()
                    .background(Color.color2) // Define o fundo do SecureField como transparente
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.horizontal, 8) // Garante o preenchimento para corresponder ao placeholder
            }
             
        }
        .padding(.horizontal)
        .padding(.top, 15) // Add padding to avoid overlap
    }
}
