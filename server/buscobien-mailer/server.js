import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import recoveryRouter from './routes/recovery.js';

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.use('/api', recoveryRouter);

app.listen(PORT, () => {
  console.log(`buscobien-mailer escuchando en puerto ${PORT}`);
});
