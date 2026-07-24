const nodemailer = require('nodemailer');

const enviarEmailRecuperacao = async (emailDestino, token) => {
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.EMAIL_USER, 
      pass: process.env.EMAIL_PASS  
    }
  });

  // O link real que o aplicativo vai ler
  // Mude a variável do link para apontar para o seu próprio servidor:
const link = `neuroflux://recuperar-senha?token=${token}`;

  await transporter.sendMail({
    from: '"Suporte Neuroflux" <' + process.env.EMAIL_USER + '>',
    to: emailDestino,
    subject: "Recuperação de Senha - Neuroflux",
    text: `Você solicitou a recuperação de senha. Acesse o link: ${link} ou use o token: ${token}`,
    
    // 2. Colocamos o link visível e o token em negrito para garantir que o usuário veja
    html: `
      <div style="font-family: Arial, sans-serif; font-size: 16px; color: #333;">
        <h2>Recuperação de Senha</h2>
        <p>Você solicitou a recuperação de senha do Neuroflux.</p>
        <p>Clique no link abaixo para redefinir:</p>
        <p><a href="${link}" style="color: #0056b3; text-decoration: none;"><b>${link}</b></a></p>
        <br>
        <p>Ou, se preferir, copie e cole o código de verificação abaixo direto no aplicativo:</p>
        <h3 style="background: #f4f4f4; padding: 10px; display: inline-block; border-radius: 5px;">${token}</h3>
      </div>
    `
  });

  console.log(`E-mail disparado com sucesso para: ${emailDestino}`);
};

module.exports = enviarEmailRecuperacao;