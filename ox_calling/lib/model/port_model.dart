import 'dart:isolate';

///Title: port_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/7/28 17:29
class PortModel {
  SendPort sendPort;
  ReceivePort controlPort;

  PortModel(this.sendPort, this.controlPort);
}