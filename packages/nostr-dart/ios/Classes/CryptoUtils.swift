//
//  CryptoUtils.swift
//  nostr_core_dart
//
//  Created by Zharlie on 2024/7/2.
//

import Foundation
import secp256k1Swift

class CryptoUtils {
    static func schnorrVerify(publicKey: Data, message: Data, signature: Data) -> Bool {
        let pubkeyBytes: [UInt8] = [0x02] + [UInt8](publicKey)
        var messageBytes: [UInt8] = [UInt8](message)
        let signatureBytes: [UInt8] = [UInt8](signature)
        
        guard let publicKey = try? secp256k1.Signing.PublicKey(rawRepresentation: pubkeyBytes, format: .compressed),
              let signature = try? secp256k1.Signing.SchnorrSignature(rawRepresentation: signatureBytes) else {
            return false
        }
        
        return publicKey.schnorr.isValid(signature, for: &messageBytes)
    }
    
    static func schnorrSign(privateKey: String, message: String, aux: String) -> String? {
        // Strict BIP340 mode is disabled by default for Schnorr signatures with variable length messages
        guard let privateKeyBytes = try? privateKey.bytes,
              var messageBytes = try? message.bytes,
              var auxBytes = try? aux.bytes,
              let privateKey = try? secp256k1.Signing.PrivateKey(rawRepresentation: privateKeyBytes, format: .compressed) else {
            return nil
        }
        
        guard let signature = try? privateKey.schnorr.signature(message: &messageBytes, auxiliaryRand: &auxBytes) else {
            return nil
        }
        
        return String(bytes: Array(signature.rawRepresentation))
    }
}
