import { Router } from 'express';
import type { Request, Response } from 'express';

export const familyRouter = Router();

/**
 * GET /api/v1/family
 * Get the current user's family details.
 */
familyRouter.get('/', (_req: Request, res: Response): void => {
  // TODO: implement with auth middleware + DB query
  res.json({ message: 'Family endpoint — implementation pending' });
});

/**
 * GET /api/v1/family/tree
 * Get the family tree data structure.
 */
familyRouter.get('/tree', (_req: Request, res: Response): void => {
  // TODO: return full family tree with person nodes and relationships
  res.json({ message: 'Family tree endpoint — implementation pending' });
});

/**
 * GET /api/v1/family/members
 * List all members of the family.
 */
familyRouter.get('/members', (_req: Request, res: Response): void => {
  // TODO: paginated list of family members
  res.json({ message: 'Family members endpoint — implementation pending' });
});

/**
 * GET /api/v1/family/birthdays
 * Get upcoming birthdays.
 */
familyRouter.get('/birthdays', (_req: Request, res: Response): void => {
  // TODO: return birthdays sorted by days until next occurrence
  res.json({ message: 'Birthdays endpoint — implementation pending' });
});
