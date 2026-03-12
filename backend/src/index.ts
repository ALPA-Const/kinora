import compression from 'compression';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';
import helmet from 'helmet';
import { createServer } from 'http';
import { Server as SocketServer } from 'socket.io';

import { errorHandler } from './middleware/errorHandler';
import { rateLimiter } from './middleware/rateLimiter';
import { requestLogger } from './middleware/requestLogger';
import { authRouter } from './routes/auth';
import { familyRouter } from './routes/family';
import { healthRouter } from './routes/health';
import { logger } from './utils/logger';

dotenv.config();

const PORT = process.env.PORT ?? 4000;
const APP_URL = process.env.APP_URL ?? 'http://localhost:3000';

const app = express();
const httpServer = createServer(app);

// Socket.io for real-time features (chat, location, presence)
export const io = new SocketServer(httpServer, {
  cors: {
    origin: APP_URL,
    credentials: true,
  },
});

// Security middleware
app.use(helmet());
app.use(
  cors({
    origin: APP_URL,
    credentials: true,
  }),
);

// Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(compression());

// Logging
app.use(requestLogger);

// Rate limiting
app.use('/api/', rateLimiter);

// Routes
app.use('/health', healthRouter);
app.use('/api/v1/auth', authRouter);
app.use('/api/v1/family', familyRouter);

// Global error handler (must be last)
app.use(errorHandler);

// WebSocket authentication
io.use((socket, next) => {
  const token = socket.handshake.auth.token as string | undefined;
  if (!token) {
    next(new Error('Authentication required'));
    return;
  }
  // TODO: verify JWT token and attach user to socket
  next();
});

io.on('connection', (socket) => {
  logger.info(`Socket connected: ${socket.id}`);

  socket.on('disconnect', () => {
    logger.info(`Socket disconnected: ${socket.id}`);
  });
});

export function startServer(): void {
  httpServer.listen(PORT, () => {
    logger.info(`Kinora API server running on port ${PORT}`);
  });
}

// Only start automatically when running the file directly (not when imported in tests)
if (require.main === module) {
  startServer();
}

export default app;
