const crypto = require('crypto');
const { Usuario } = require('../models'); 
// COLOQUE ISTO NO LUGAR:
const enviarEmailRecuperacao = require('../utils/sendEmail');

module.exports = {
  async esqueciSenha(req, res) {
    const { email } = req.body;

    try {
      const usuario = await Usuario.findOne({ where: { email } });

      if (!usuario) {
        return res.status(404).json({ erro: 'Usuário não encontrado com esse e-mail.' });
      }

      const token = crypto.randomBytes(20).toString('hex');
      
      const validade = new Date();
      validade.setHours(validade.getHours() + 1);

      await usuario.update({
        tokenRecuperacao: token,
        validadeTokenRecuperacao: validade
      });

      await enviarEmailRecuperacao(usuario.email, token);

      return res.status(200).json({ mensagem: 'E-mail de recuperação enviado com sucesso!' });

    } catch (error) {
      console.error(error);
      return res.status(500).json({ erro: 'Erro ao tentar recuperar a senha.' });
    }
  },

  async resetarSenha(req, res) {
    const { token, novaSenha } = req.body;

    try {
      const usuario = await Usuario.findOne({ 
        where: { tokenRecuperacao: token } 
      });

      if (!usuario) {
        return res.status(400).json({ erro: 'Token inválido ou não encontrado.' });
      }

      if (new Date() > usuario.validadeTokenRecuperacao) {
         return res.status(400).json({ erro: 'O token expirou. Solicite a recuperação novamente.' });
      }

      usuario.senha = novaSenha;
      usuario.tokenRecuperacao = null;
      usuario.validadeTokenRecuperacao = null;
      
      await usuario.save();

      return res.status(200).json({ mensagem: 'Senha alterada com sucesso!' });

    } catch (error) {
      console.error(error);
      return res.status(500).json({ erro: 'Erro ao redefinir a senha.' });
    }
  }
};