import { Router } from 'express';
import { body, validationResult } from 'express-validator';

import type { NextFunction, Request, Response } from 'express';

import { codeValidationRateLimiter, loginRateLimiter } from '../middleware/rateLimiter';
import { LicenseCodeService } from '../services/licenseCodeService';
import { createError } from '../middleware/errorHandler';

export const authRouter = Router();

const licenseCodeService = new LicenseCodeService();

/**
 * POST /api/v1/auth/validate-code
 * Validate a family license code before registration.
 */
authRouter.post(
  '/validate-code',
  codeValidationRateLimiter,
  [
    body('code')
      .trim()
      .matches(/^KINORA-[A-Z0-9]+-\d{4}-[A-Z0-9]{4}$/i)
      .withMessage('Invalid license code format'),
  ],
  async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      next(createError('Invalid license code format', 400, 'INVALID_CODE_FORMAT'));
      return;
    }

    const { code } = req.body as { code: string };

    try {
      const profile = await licenseCodeService.validate(code);

      if (!profile) {
        next(createError('License code not found or already used', 404, 'CODE_NOT_FOUND'));
        return;
      }

      res.json({
        valid: true,
        profile: {
          assignedName: profile.assignedName,
          invitedBy: profile.invitedBy,
          relationship: profile.relationship,
          preferredLanguage: profile.preferredLanguage,
        },
      });
    } catch (err) {
      next(err);
    }
  },
);

/**
 * POST /api/v1/auth/register
 * Complete registration after code validation.
 */
authRouter.post(
  '/register',
  codeValidationRateLimiter,
  [
    body('code').trim().notEmpty().withMessage('License code is required'),
    body('email').isEmail().normalizeEmail().withMessage('Valid email is required'),
    body('password')
      .isLength({ min: 8 })
      .withMessage('Password must be at least 8 characters')
      .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
      .withMessage('Password must contain uppercase, lowercase and a number'),
    body('displayName').trim().isLength({ min: 2, max: 50 }).withMessage('Display name required'),
  ],
  async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      next(createError('Validation failed', 400, 'VALIDATION_ERROR'));
      return;
    }

    // TODO: implement full registration flow
    try {
      res.status(201).json({ message: 'Registration endpoint — implementation pending' });
    } catch (err) {
      next(err);
    }
  },
);

/**
 * POST /api/v1/auth/login
 * Authenticate an existing user.
 */
authRouter.post(
  '/login',
  loginRateLimiter,
  [
    body('email').isEmail().normalizeEmail(),
    body('password').notEmpty(),
  ],
  async (_req: Request, res: Response, next: NextFunction): Promise<void> => {
    // TODO: implement JWT-based login
    try {
      res.status(200).json({ message: 'Login endpoint — implementation pending' });
    } catch (err) {
      next(err);
    }
  },
);

/**
 * POST /api/v1/auth/refresh
 * Rotate refresh token and return new access token.
 */
authRouter.post('/refresh', async (_req: Request, res: Response, next: NextFunction): Promise<void> => {
  // TODO: implement token rotation
  try {
    res.status(200).json({ message: 'Token refresh endpoint — implementation pending' });
  } catch (err) {
    next(err);
  }
});

/**
 * POST /api/v1/auth/logout
 * Invalidate the current refresh token.
 */
authRouter.post('/logout', (_req: Request, res: Response): void => {
  // TODO: invalidate refresh token in Redis/DB
  res.clearCookie('refreshToken');
  res.status(204).send();
});
