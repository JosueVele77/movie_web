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
            ps.setBoolean(2, !ocultar);
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
}