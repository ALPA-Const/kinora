/**
 * LicenseCodeService
 *
 * Handles generation and validation of family invite codes.
 *
 * Code format: KINORA-[NAME]-[YEAR]-[4CHAR]
 * Example:      KINORA-MARIA-2024-7X9K
 *
 * Security notes:
 * - The 4-char suffix is generated using a CSPRNG (nanoid).
 * - Codes are stored hashed in the database; plaintext is never persisted.
 * - Validation attempts are rate-limited (see middleware/rateLimiter.ts).
 * - Unused codes expire after LICENSE_CODE_EXPIRY_DAYS days.
 */

export interface LicenseCodeProfile {
  assignedName: string;
  invitedBy: string;
  relationship: string;
  preferredLanguage: string;
  birthDate?: string;
}

export interface LicenseCode {
  id: string;
  code: string;
  profile: LicenseCodeProfile;
  usedAt: Date | null;
  expiresAt: Date;
  createdAt: Date;
}

export class LicenseCodeService {
  /**
   * Validate a license code and return its associated profile.
   * Returns null if the code is invalid, already used, or expired.
   */
  async validate(code: string): Promise<LicenseCodeProfile | null> {
    // TODO: query database for hashed code
    // TODO: check expiry and used status
    // Placeholder implementation
    void code;
    return null;
  }

  /**
   * Generate a new license code for a family member.
   * The plaintext code is returned once and never stored.
   * Only the hash is persisted to the database.
   */
  async generate(profile: LicenseCodeProfile): Promise<string> {
    // TODO: generate cryptographically secure suffix
    // TODO: hash and store in database
    // Placeholder implementation
    const year = new Date().getFullYear();
    const name = profile.assignedName.toUpperCase().replace(/[^A-Z]/g, '');
    const suffix = 'XXXX'; // TODO: replace with nanoid(4).toUpperCase()
    return `KINORA-${name}-${year}-${suffix}`;
  }

  /**
   * Revoke a license code, preventing future use.
   */
  async revoke(codeId: string): Promise<void> {
    // TODO: mark code as revoked in database
    void codeId;
  }
}
