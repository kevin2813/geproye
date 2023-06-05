/* import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:simple_peer/simple_peer.dart';

final supabase = Supabase.instance.client;

class Chat
{
  String email = '';
  String ip = '';
  late IO.Socket socket;
  late Peer peer;
  void init() async {
    socket = IO.io(dotenv.env['SERVER_URL']);
    email = supabase.auth.currentUser!.email ?? '';
    final resIp = await http.get(Uri.parse('https://api.ipify.org'));
    ip = resIp.body;

    // Registrar cliente disponible para P2P
    socket.onConnect((_) {
      print('connected');
      socket.emit('register', { 
        'clientId': email,
      });
    });

    socket.onDisconnect((_) {
      print('disconnected');
    });

    /* // Solicitar información del cliente destinatario para establecer P2P
    socket.emit('p2pRequest', {
      targetClientId: 'targetClientId'
    }); */
    

    // Escuchar la respuesta del servidor con la información del cliente destinatario
    socket.on('p2pInfo', (data) async {
      // Crear una instancia de RTCPeerConnection
      // Establecer conexión P2P utilizando WebRTC
      final targetClientId = data.targetClientId;
      final targetIpAddress = data.targetIp;
      final targetPort = data.targetPort;
      // Crear una nueva instancia de SimplePeer
      peer = await Peer.create(
        initiator: true,
        config: {
          "trickle": false,
        }
      );

      // Escuchar eventos de SimplePeer
      peer.onSignal = (signal) {
        // Enviar la señal de inicio al servidor
        socket.emit('startP2P', {
          'targetSocketId': data['targetSocketId'],
          'offerSdp': signal.encode(),
        });
      };

      peer.onConnect = (_) {
        // La conexión P2P se ha establecido
        print('Conexión P2P establecida');
      };

      peer.onData = (data) {
        // Datos recibidos de la conexión P2P
        print('Datos recibidos de la conexión P2P: $data');
      };

      // Establecer la oferta SDP recibida
      peer.signal(Signal.fromJson(data['offerSdp']));
    });

    // Manejar errores si el cliente destinatario no está disponible
    socket.on('p2pError', (errorMessage) {
      print('Error en la solicitud P2P: $errorMessage');
    });
  }

  String _updateSdpIpAddress(String sdp, String ipAddress, String port) {
    final lines = sdp.split('\r\n');
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('c=')) {
        final parts = lines[i].split(' ');
        parts[2] = ipAddress;
        parts[3] = port;
        lines[i] = parts.join(' ');
        break;
      }
    }
    return lines.join('\r\n');
  }
} */