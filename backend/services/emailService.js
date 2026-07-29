const { Resend } = require('resend');

const resend = new Resend(process.env.RESEND_API_KEY);

async function sendPasswordResetEmail(destinatarioEmail, nomeUsuario, resetToken) {
  const resetLink = `neuroflux://reset-password?token=${resetToken}`;

  await resend.emails.send({
    from: 'Neuroflux <onboarding@resend.dev>',
    to: destinatarioEmail,
    subject: 'Recupere sua senha - Neuroflux',
    html: `
      <div style="font-family: sans-serif; max-width: 480px; margin: 0 auto;">
        <h2 style="color: #F3722C;">Olá, ${nomeUsuario}!</h2>
        <p>Recebemos uma solicitação para redefinir sua senha no Neuroflux.</p>
        <p>Use o código abaixo no app para criar uma nova senha:</p>
        <div style="background: #FFF3EC; padding: 16px; border-radius: 12px; text-align: center; margin: 24px 0;">
          <span style="font-size: 24px; font-weight: bold; letter-spacing: 2px; color: #F3722C;">
            ${resetToken}
          </span>
        </div>
        <p style="color: #666; font-size: 13px;">
          Este código expira em 30 minutos. Se você não solicitou essa alteração, 
          pode ignorar este e-mail com segurança.
        </p>
      </div>
    `,
  });
}

module.exports = { sendPasswordResetEmail };