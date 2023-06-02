class ChatUser {
  final String? email;
  final String? ip;

  ChatUser(
    {this.email,
    this.ip
    });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      email: json['email'],
      ip: json['ip'],
    );
  }

  Map toMap() {
    return {
      'email': email,
      'ip': ip,
    };
  }
}
