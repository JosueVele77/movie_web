package io.github.josuevele77.movie_web.dao;

import io.github.josuevele77.movie_web.config.DatabaseConnection;
import java.sql.*;

public class ProductoDAO {

    // El Empleado puede cambiar precio y ocultar (estado_pr = false)
    public boolean actualizarPorEmpleado(int idPr, double precio, boolean ocultar) {
        String sql = "UPDATE public.tb_producto SET precio_pr = ?, estado_pr = ? WHERE id_pr = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, precio);
            // Si elige ocultar se envía false, si no, mantiene su visibilidad actual
            ps.setBoolean(2, ocultar);
            ps.setInt(3, idPr);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Solo el Administrador puede reactivar el producto (estado_pr = true)
    public boolean reactivarProducto(int idPr) {
        String sql = "UPDATE public.tb_producto SET estado_pr = TRUE WHERE id_pr = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPr);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Métodos para estadísticas y control del Administrador
    public int contarTotalProductos() {
        String sql = "SELECT COUNT(*) FROM public.tb_producto";
        try (Connection con = io.github.josuevele77.movie_web.config.DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int contarProductosOcultos() {
        String sql = "SELECT COUNT(*) FROM public.tb_producto WHERE estado_pr = FALSE";
        try (Connection con = io.github.josuevele77.movie_web.config.DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Devuelve la lista de películas inactivas que el empleado ocultó
    public java.util.List<io.github.josuevele77.movie_web.model.Producto> listarOcultos() {
        java.util.List<io.github.josuevele77.movie_web.model.Producto> lista = new java.util.ArrayList<>();
        String sql = "SELECT * FROM public.tb_producto WHERE estado_pr = FALSE ORDER BY id_pr DESC";
        try (Connection con = io.github.josuevele77.movie_web.config.DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                io.github.josuevele77.movie_web.model.Producto p = new io.github.josuevele77.movie_web.model.Producto();
                p.setIdPr(rs.getInt("id_pr"));
                p.setIdCat(rs.getInt("id_cat"));
                p.setNombrePr(rs.getString("nombre_pr"));
                p.setCantidadPr(rs.getInt("cantidad_pr"));
                p.setPrecioPr(rs.getDouble("precio_pr"));
                p.setEstadoPr(rs.getBoolean("estado_pr"));
                lista.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }
}