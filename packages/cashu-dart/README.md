[![License: LGPL v3](https://img.shields.io/badge/License-LGPL_v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)

# Cashu-dart

## Introduction

Cashu-dart is a library written in the Dart programming language, specifically designed to implement and support the protocols of [Cashu](https://github.com/cashubtc). This library aims to provide Dart developers with a simple and efficient way to integrate and utilize the Cashu protocols.

## Supported Protocols

Cashu-dart supports the following Cashu protocols:

- [NUTS 00](https://github.com/cashubtc/nuts/blob/main/00.md)
- [NUTS 01](https://github.com/cashubtc/nuts/blob/main/01.md)
- [NUTS 02](https://github.com/cashubtc/nuts/blob/main/02.md)
- [NUTS 03](https://github.com/cashubtc/nuts/blob/main/03.md)
- [NUTS 04](https://github.com/cashubtc/nuts/blob/main/04.md)
- [NUTS 05](https://github.com/cashubtc/nuts/blob/main/05.md)
- [NUTS 06](https://github.com/cashubtc/nuts/blob/main/06.md)
- [NUTS 07](https://github.com/cashubtc/nuts/blob/main/07.md)
- [NUTS 08](https://github.com/cashubtc/nuts/blob/main/08.md)
- [NUTS 11](https://github.com/cashubtc/nuts/blob/main/11.md)

## Token Format Support

Cashu-dart provides support for the following token formats:

- :x: v1 read (deprecated)
- :x: v2 read (deprecated)
- :heavy_check_mark: [v3](https://github.com/cashubtc/nuts/blob/main/00.md#023---v3-tokens) read/write

## Usage Example

```dart
import 'package:cashu_dart/cashu_dart.dart';

// Redeem
Cashu.redeemEcash(ecashString: ecashToken);

// Send
Cashu.sendEcash(
  mint: IMint(
    mintURL: 'https://testnut.cashu.space',
  ),
  amount: 21,
  memo: 'Sent via Cashu-dart.'
);

// Create invoice
Cashu.createLightningInvoice(
  mint: IMint(
    mintURL: 'https://testnut.cashu.space',
  ),
  amount: 21,
);

// Pay invoice
Cashu.payingLightningInvoice(
  mint: IMint(
    mintURL: 'https://testnut.cashu.space',
  ),
  pr: 'lnbc.....',
);

```

## Contributing

Contributions are welcome! Please read our contribution guide to learn how you can participate in the development of this project.

## License

Cashu-dart is released under the [GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0).
