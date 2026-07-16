import { Router } from 'express';
import nodemailer from 'nodemailer';
import { readFile } from 'fs/promises';
import { fileURLToPath } from 'url';
import path from 'path';

const router = Router();
const __dirname = path.dirname(fileURLToPath(import.meta.url));

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: Number(process.env.SMTP_PORT) || 587,
  secure: Number(process.env.SMTP_PORT) === 465,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
});

router.post('/enviar-correo-recuperacion', async (req, res) => {
  const { email, nombreUsuario, resetToken, perfil } = req.body;

  if (!email || !nombreUsuario || !resetToken || !perfil) {
    return res.status(400).json({ error: 'Faltan campos requeridos', code: 'MISSING_FIELDS' });
  }

  try {
    const templatePath = path.join(__dirname, '../templates/recovery-email.html');
    let html = await readFile(templatePath, 'utf8');

    const deepLink = `${process.env.DEEP_LINK_BASE}?token=${resetToken}&perfil=${encodeURIComponent(perfil)}`;

    html = html
      .replace(/{{nombreUsuario}}/g, nombreUsuario)
      .replace(/{{deepLink}}/g, deepLink)
      .replace(/{{perfil}}/g, perfil);

    await transporter.sendMail({
      from: process.env.SMTP_FROM,
      to: email,
      subject: 'Recuperación de contraseña — BuscoBien',
      html,
    });

    res.json({ success: true, message: 'Correo enviado' });
  } catch (err) {
    console.error('Error enviando correo:', err);
    res.status(500).json({ error: 'Error al enviar el correo', code: 'SMTP_ERROR' });
  }
});

export default router;
