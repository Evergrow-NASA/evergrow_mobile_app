import 'package:flutter/material.dart';
import 'package:evergrow_mobile_app/utils/theme.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4.0, bottom: 8.0), // Ajuste de margen para mantener espacio exacto
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: isUser ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(isUser ? 15.0 : 0), // Esquinas ajustadas para la forma del mensaje
              bottomRight: Radius.circular(isUser ? 0 : 15.0),
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0),
            ),
            border: Border.all( // Borde alrededor del mensaje
              color: isUser ? Colors.transparent : AppTheme.primaryColor, // Borde solo en mensajes del otro usuario
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isUser ? Colors.white : AppTheme.primaryColor,
              fontSize: 16,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser)
              const Icon(Icons.volume_up, color: AppTheme.secondaryColor, size: 24), // Ajuste de tamaño exacto del ícono
            if (!isUser) const SizedBox(width: 4), // Espaciado entre icono y hora
            Text(
              time,
              style: const TextStyle(color: AppTheme.secondaryColor, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 10), // Ajuste del espacio debajo de la fecha
      ],
    );
  }
}
