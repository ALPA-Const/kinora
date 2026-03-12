import { LicenseCodeService } from '../src/services/licenseCodeService';

describe('LicenseCodeService', () => {
  const service = new LicenseCodeService();

  describe('generate', () => {
    it('generates a code matching the expected format', async () => {
      const code = await service.generate({
        assignedName: 'Maria',
        invitedBy: 'Bill Asmar',
        relationship: 'daughter',
        preferredLanguage: 'en',
      });

      expect(code).toMatch(/^KINORA-[A-Z]+-\d{4}-[A-Z0-9]{4}$/);
    });

    it('uppercases and strips non-alpha chars from the name segment', async () => {
      const code = await service.generate({
        assignedName: 'Grand-Ma',
        invitedBy: 'Bill Asmar',
        relationship: 'grandmother',
        preferredLanguage: 'en',
      });

      expect(code).toContain('KINORA-GRANDMA-');
    });
  });

  describe('validate', () => {
    it('returns null for an unknown code (placeholder implementation)', async () => {
      const result = await service.validate('KINORA-TEST-2024-ABCD');
      expect(result).toBeNull();
    });
  });

  describe('revoke', () => {
    it('resolves without error (placeholder implementation)', async () => {
      await expect(service.revoke('some-id')).resolves.toBeUndefined();
    });
  });
});
