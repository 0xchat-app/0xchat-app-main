import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_image.dart';

/// Renders the verified-NIP-05 indicator next to a contact's
/// identifier. Picks one of two visuals:
///
///   * the existing DNS check icon (`icon_npi05_verified.png`) for
///     standard `name@example.com` handles, or
///   * a Namecoin-flavoured chain badge for `name@example.bit`
///     handles whose pubkey was verified against the Namecoin
///     blockchain.
///
/// The split exists so users can tell DNS-backed identities apart
/// from chain-backed ones at a glance — relevant for DM clients
/// because DNS NIP-05 records can be rotated silently (by the domain
/// owner or by a DNS-level attacker) while a `.bit` record cannot.
///
/// Designed as a drop-in replacement for the existing inline
/// `CommonImage(iconName: "icon_npi05_verified.png", ...)` widget so
/// existing layouts keep working without rework.
class Nip05VerifiedBadge extends StatelessWidget {
  /// The full NIP-05 identifier (`alice@example.com`,
  /// `alice@example.bit`, etc.). Used to detect the `.bit` suffix.
  final String dns;

  /// `true` when the identifier has been verified (either via
  /// `.well-known/nostr.json` or via the Namecoin blockchain).
  final bool isVerified;

  /// Icon size in logical pixels.
  final double size;

  const Nip05VerifiedBadge({
    super.key,
    required this.dns,
    required this.isVerified,
    this.size = 16,
  });

  /// `true` when the right-hand side of [dns] ends in `.bit`. Cheap
  /// helper exposed so call sites can read the same condition
  /// without having to round-trip through the widget.
  static bool isNamecoinDomain(String dns) {
    if (dns.isEmpty) return false;
    final atIdx = dns.indexOf('@');
    final domain = atIdx >= 0 ? dns.substring(atIdx + 1) : dns;
    return isBitDomain(domain);
  }

  @override
  Widget build(BuildContext context) {
    if (!isVerified || dns.isEmpty) {
      return const SizedBox.shrink();
    }
    if (isNamecoinDomain(dns)) {
      // Chain-backed identity: stack a small "₦" mark over a link
      // glyph so the badge reads as "Namecoin link" rather than
      // "DNS check". Tooltip explains the distinction.
      return Tooltip(
        message: 'Verified via Namecoin (.bit)',
        child: Icon(
          Icons.link,
          size: size,
          // Namecoin brand orange. Falls back to the platform's
          // default if the theme provides a stronger override.
          color: const Color(0xFFB78D17),
        ),
      );
    }
    // DNS-backed identity: existing check icon, kept verbatim so
    // pixel-perfect layouts that rely on the asset don't drift.
    return CommonImage(
      iconName: 'icon_npi05_verified.png',
      width: size,
      height: size,
      package: 'ox_common',
    );
  }
}
