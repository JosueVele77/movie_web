package io.github.josuevele77.movie_web.dao;

import io.github.josuevele77.movie_web.config.DatabaseConnection;
import io.github.josuevele77.movie_web.model.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsuarioDAO {

    // Método para iniciar sesión y obtener el perfil/rol
    public Usuario login(String correo, String clave) {
        String sql = "SELECT u.*, p.descripcion_per FROM public.tb_usuario u " +
                "JOIN public.tb_perfil p ON u.id_per = p.id_per " +
                "WHERE TRIM(u.correo_us) = ? AND TRIM(u.clave_us) = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo);
            ps.setString(2, clave);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setIdUs(rs.getInt("id_us"));
                    u.setIdPer(rs.getInt("id_per")); // Verifica que llame a setIdPer (con P mayúscula)
                    u.setIdEst(rs.getInt("id_est"));
                    u.setNombreUs(rs.getString("nombre_us"));
                    u.setCedulaUs(rs.getString("cedula_us"));
                    u.setCorreoUs(rs.getString("correo_us"));
                    u.setClaveUs(rs.getString("clave_us"));
                    u.setAvatarUrl(rs.getString("avatar_url"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Si las credenciales son incorrectas o hay error
    }

    // Método para registrar un nuevo Cliente con su Estado Civil
    public boolean registrar(Usuario u) {
        String sql = "INSERT INTO public.tb_usuario (id_per, id_est, nombre_us, cedula_us, correo_us, clave_us, avatar_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, 3); // Por defecto, todo registro desde la web es 'Cliente' (ID 3)
            ps.setInt(2, u.getIdEst()); // ID del estado civil seleccionado en el combo box
            ps.setString(3, u.getNombreUs());
            ps.setString(4, u.getCedulaUs());
            ps.setString(5, u.getCorreoUs());
            ps.setString(6, u.getClaveUs());
            ps.setString(7, u.getAvatarUrl());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Agrega este método al final de tu UsuarioDAO para contar los usuarios registrados
    public int contarClientes() {
        String sql = "SELECT COUNT(*) FROM public.tb_usuario WHERE id_per = 3";
        try (Connection con = io.github.josuevele77.movie_web.config.DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Método para actualizar los datos personales del perfil del cliente
    public boolean actualizarPerfil(Usuario u) {
        String sql = "UPDATE public.tb_usuario SET nombre_us = ?, cedula_us = ?, correo_us = ?, clave_us = ? WHERE id_us = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getNombreUs());
            ps.setString(2, u.getCedulaUs());
            ps.setString(3, u.getCorreoUs());
            ps.setString(4, u.getClaveUs());
            ps.setInt(5, u.getIdUs());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}