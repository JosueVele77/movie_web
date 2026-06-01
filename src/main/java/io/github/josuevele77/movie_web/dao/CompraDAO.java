package io.github.josuevele77.movie_web.dao;

import io.github.josuevele77.movie_web.config.DatabaseConnection;
import io.github.josuevele77.movie_web.model.HistorialCompra;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompraDAO {

    /**
     * Registra una compra en la base de datos
     */
    public int registrarCompra(int idUsuario, double totalCompra, String titularTarjeta, String numeroTarjeta) {
        String sql = "INSERT INTO public.tb_compra (id_us, fecha_com, total_com, tarjeta_titular, tarjeta_numero) " +
                     "VALUES (?, NOW(), ?, ?, ?) RETURNING id_com";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setDouble(2, totalCompra);
            ps.setString(3, titularTarjeta);
            ps.setString(4, numeroTarjeta);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("id_com");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Registra el detalle de un producto comprado
     */
    public boolean registrarDetalleCompra(int idCompra, int idProducto, int cantidad, double precio) {
        String sql = "INSERT INTO public.tb_detalle_compra (id_com, id_pr, cantidad_det, precio_det) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCompra);
            ps.setInt(2, idProducto);
            ps.setInt(3, cantidad);
            ps.setDouble(4, precio);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Obtiene el historial de compras de un usuario
     */
    public List<HistorialCompra> obtenerHistorialPorUsuario(int idUsuario) {
        List<HistorialCompra> historial = new ArrayList<>();
        String sql = "SELECT dc.id_pr, p.nombre_pr, c.fecha_com, c.total_com " +
                     "FROM public.tb_compra c " +
                     "JOIN public.tb_detalle_compra dc ON c.id_com = dc.id_com " +
                     "JOIN public.tb_producto p ON dc.id_pr = p.id_pr " +
                     "WHERE c.id_us = ? " +
                     "ORDER BY c.fecha_com DESC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                HistorialCompra compra = new HistorialCompra();
                compra.setNombrePelicula(rs.getString("nombre_pr"));
                compra.setFechaCompra(rs.getTimestamp("fecha_com"));
                compra.setTotal(rs.getDouble("total_com"));
                historial.add(compra);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return historial;
    }

    /**
     * Obtiene el historial de todas las compras (para administradores)
     */
    public List<HistorialCompra> obtenerHistorial() {
        List<HistorialCompra> historial = new ArrayList<>();
        String sql = "SELECT u.nombre_us, dc.id_pr, p.nombre_pr, c.fecha_com, c.total_com " +
                     "FROM public.tb_compra c " +
                     "JOIN public.tb_detalle_compra dc ON c.id_com = dc.id_com " +
                     "JOIN public.tb_producto p ON dc.id_pr = p.id_pr " +
                     "JOIN public.tb_usuario u ON c.id_us = u.id_us " +
                     "ORDER BY c.fecha_com DESC";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                HistorialCompra compra = new HistorialCompra();
                compra.setNombreUsuario(rs.getString("nombre_us"));
                compra.setNombrePelicula(rs.getString("nombre_pr"));
                compra.setFechaCompra(rs.getTimestamp("fecha_com"));
                compra.setTotal(rs.getDouble("total_com"));
                historial.add(compra);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return historial;
    }

    /**
     * Obtiene todas las películas compradas por un usuario (sin duplicados)
     */
    public List<String> obtenerPelículasCompradasPorUsuario(int idUsuario) {
        List<String> peliculas = new ArrayList<>();
        String sql = "SELECT DISTINCT p.id_pr, p.nombre_pr " +
                     "FROM public.tb_compra c " +
                     "JOIN public.tb_detalle_compra dc ON c.id_com = dc.id_com " +
                     "JOIN public.tb_producto p ON dc.id_pr = p.id_pr " +
                     "WHERE c.id_us = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                peliculas.add(rs.getInt("id_pr") + ":" + rs.getString("nombre_pr"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return peliculas;
    }

    public List<String> obtenerPeliculasCompradasPorUsuario(int idUsuario) {
        return obtenerPelículasCompradasPorUsuario(idUsuario);
    }

    /**
     * Cuenta total de compras de un usuario
     */
    public int contarComprasPorUsuario(int idUsuario) {
        String sql = "SELECT COUNT(DISTINCT id_com) as total FROM public.tb_compra WHERE id_us = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Verifica si un usuario ya compró un producto
     */
    public boolean usuarioPoseeProducto(int idUsuario, int idProducto) {
        String sql = "SELECT 1 FROM public.tb_compra c " +
                     "JOIN public.tb_detalle_compra dc ON c.id_com = dc.id_com " +
                     "WHERE c.id_us = ? AND dc.id_pr = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idProducto);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
