package io.github.josuevele77.movie_web.dao;

import io.github.josuevele77.movie_web.config.DatabaseConnection;
import io.github.josuevele77.movie_web.model.Favorito;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FavoritoDAO {

    public List<Favorito> listarPorUsuario(int idUsuario) {
        List<Favorito> favoritos = new ArrayList<>();
        String sql = "SELECT tmdb_id, titulo, poster_path, release_year " +
                     "FROM public.tb_favorito WHERE id_us = ? ORDER BY creado_en DESC";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Favorito favorito = new Favorito();
                favorito.setTmdbId(rs.getInt("tmdb_id"));
                favorito.setTitle(rs.getString("titulo"));
                favorito.setPosterPath(rs.getString("poster_path"));
                favorito.setReleaseYear(rs.getString("release_year"));
                favoritos.add(favorito);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return favoritos;
    }

    public boolean existeFavorito(int idUsuario, int tmdbId) {
        String sql = "SELECT 1 FROM public.tb_favorito WHERE id_us = ? AND tmdb_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, tmdbId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean agregarFavorito(int idUsuario, int tmdbId, String titulo, String posterPath, String releaseYear) {
        String sql = "INSERT INTO public.tb_favorito (id_us, tmdb_id, titulo, poster_path, release_year) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, tmdbId);
            ps.setString(3, titulo);
            ps.setString(4, posterPath);
            ps.setString(5, releaseYear);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminarFavorito(int idUsuario, int tmdbId) {
        String sql = "DELETE FROM public.tb_favorito WHERE id_us = ? AND tmdb_id = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, tmdbId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

