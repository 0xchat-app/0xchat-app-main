# NUT-02 test fixtures

Fixtures mirror GET /v1/keysets response shape. Used by `test/nut02/selection_test.dart`.

- **keysets_v1.json**: Only V1 keyset ids (16 hex, prefix `00`).
- **keysets_v2.json**: Only V2 keyset ids (66 hex, prefix `01`); includes `input_fee_ppk`, `final_expiry` boundaries.
- **keysets_mixed.json**: V1 + V2 + invalid id; asserts selection prefers V2 and skips non-hex.

Fields per keyset: `id`, `unit`, `active`, `input_fee_ppk`, `final_expiry` (optional).
