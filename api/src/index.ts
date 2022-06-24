import http from 'http';
import app from './app.js';
import getRedisClient from './db.js';
import { RedisClient } from './types/redis-client.js';


const port = process.env.PORT || 3000;
app.set('port', port);

const db: RedisClient = await getRedisClient();
app.locals.db = db;

const server = http.createServer(app);

server.listen(port, () => {
  console.log(`listening on http://+:${port}`);
}).on('error', async err => {
  console.log(`Error starting on ${port}`, {err});
  await db.quit();
  process.exit(1);
});
