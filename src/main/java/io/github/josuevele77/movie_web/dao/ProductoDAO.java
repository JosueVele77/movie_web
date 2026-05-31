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
            // Si elige ocultar se envÃ­a false, si no, mantiene su visibilidad actual
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
            int idCategoria = obtenerOCrearCategoriaDefault(con);
            ps.setInt(1, idPr);
            ps.setInt(2, idCategoria);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // MÃ©todos para estadÃ­sticas y control del Administrador
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

    // Devuelve la lista de pelÃ­culas inactivas que el empleado ocultÃ³
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

    // Devuelve la lista de todas las pelÃ­culas activas (para vendedores)
    public java.util.List<io.github.josuevele77.movie_web.model.Producto> listarTodos() {
        java.util.List<io.github.josuevele77.movie_web.model.Producto> lista = new java.util.ArrayList<>();
        String sql = "SELECT * FROM public.tb_producto WHERE estado_pr = TRUE ORDER BY id_pr DESC";
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

    // MÃ©todo para que vendedor oculte un producto
    public boolean ocultarProducto(int idPr) {
        String sql = "UPDATE public.tb_producto SET estado_pr = FALSE WHERE id_pr = ?";
        try (Connection con = io.github.josuevele77.movie_web.config.DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPr);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // MÃ©todo para actualizar precio y descuento
    public boolean actualizarPrecio(int idPr, double nuevoPrecio, double descuento) {
        String sql = "UPDATE public.tb_producto SET precio_pr = ? WHERE id_pr = ?";
        try (Connection con = io.github.josuevele77.movie_web.config.DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            double precioFinal = nuevoPrecio - (nuevoPrecio * descuento / 100);
            ps.setDouble(1, precioFinal);
            ps.setInt(2, idPr);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean existeProducto(int idPr) {
        String sql = "SELECT 1 FROM public.tb_producto WHERE id_pr = ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPr);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean registrarProductoBasico(int idPr, String nombrePr, double precioPr) {
        String sql = "INSERT INTO public.tb_producto (id_pr, id_cat, nombre_pr, cantidad_pr, precio_pr, estado_pr) " +
                "VALUES (?, ?, ?, 1, ?, TRUE)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int idCategoria = obtenerOCrearCategoriaDefault(con);
            ps.setInt(1, idPr);
            ps.setInt(2, idCategoria);
            ps.setString(3, nombrePr == null || nombrePr.trim().isEmpty() ? "Pelicula" : nombrePr.trim());
            ps.setDouble(4, precioPr);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private int obtenerOCrearCategoriaDefault(Connection con) throws SQLException {
        String buscarSql = "SELECT id_cat FROM public.tb_categoria ORDER BY id_cat LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(buscarSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("id_cat");
            }
        }

        String insertarSql = "INSERT INTO public.tb_categoria (descripcion_cat) VALUES (?) RETURNING id_cat";
        try (PreparedStatement ps = con.prepareStatement(insertarSql)) {
            ps.setString(1, "Peliculas digitales");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_cat");
                }
            }
        }

        throw new SQLException("No se pudo obtener o crear una categoria para el producto.");
    }
}
