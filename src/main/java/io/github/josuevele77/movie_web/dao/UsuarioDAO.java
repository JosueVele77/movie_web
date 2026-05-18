package io.github.josuevele77.movie_web.dao;

import io.github.josuevele77.movie_web.config.DatabaseConnection;
import io.github.josuevele77.movie_web.model.Usuario;
import java.sql.*;

public class UsuarioDAO {

    public Usuario login(String correo, String clave) {
        String sql = "SELECT * FROM public.tb_usuario WHERE correo_us = ? AND clave_us = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo);
            ps.setString(2, clave);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUs(rs.getInt("id_us"));
                u.setIdPer(rs.getInt("id_per"));
                u.setIdEst(rs.getInt("id_est"));
                u.setNombreUs(rs.getString("nombre_us"));
                u.setCorreoUs(rs.getString("correo_us"));
                return u;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean registrar(Usuario u) {
        String sql = "INSERT INTO public.tb_usuario (id_per, id_est, nombre_us, cedula_us, correo_us, clave_us) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, 3); // Todo registro web por defecto es Cliente (perfil 3)
            ps.setInt(2, u.getIdEst()); // Combo box del Estado Civil
            ps.setString(3, u.getNombreUs());
            ps.setString(4, u.getCedulaUs());
            ps.setString(5, u.getCorreoUs());
            ps.setString(6, u.getClaveUs());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}