package io.github.josuevele77.movie_web.dao;

import io.github.josuevele77.movie_web.model.HistorialCompra;
import java.util.ArrayList;
import java.util.List;

public class CompraDAO {

    private List<HistorialCompra> historialCompras = new ArrayList<>();

    public void agregarCompra(HistorialCompra compra) {
        historialCompras.add(compra);
    }

    public List<HistorialCompra> obtenerHistorial() {
        return new ArrayList<>(historialCompras);
    }

    public int contarCompras() {
        return historialCompras.size();
    }
}
