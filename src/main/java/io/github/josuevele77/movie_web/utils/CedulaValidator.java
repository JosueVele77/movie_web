package io.github.josuevele77.movie_web.utils;

import java.util.HashMap;
import java.util.Map;

public class CedulaValidator {

    private static final Map<String, String> PROVINCIAS_ECUADOR = new HashMap<>();

    // Bloque estático para inicializar el diccionario de provincias una sola vez
    static {
        PROVINCIAS_ECUADOR.put("01", "Azuay");
        PROVINCIAS_ECUADOR.put("02", "Bolívar");
        PROVINCIAS_ECUADOR.put("03", "Cañar");
        PROVINCIAS_ECUADOR.put("04", "Carchi");
        PROVINCIAS_ECUADOR.put("05", "Cotopaxi");
        PROVINCIAS_ECUADOR.put("06", "Chimborazo");
        PROVINCIAS_ECUADOR.put("07", "El Oro");
        PROVINCIAS_ECUADOR.put("08", "Esmeraldas");
        PROVINCIAS_ECUADOR.put("09", "Guayas");
        PROVINCIAS_ECUADOR.put("10", "Imbabura");
        PROVINCIAS_ECUADOR.put("11", "Loja");
        PROVINCIAS_ECUADOR.put("12", "Los Ríos");
        PROVINCIAS_ECUADOR.put("13", "Manabí");
        PROVINCIAS_ECUADOR.put("14", "Morona Santiago");
        PROVINCIAS_ECUADOR.put("15", "Napo");
        PROVINCIAS_ECUADOR.put("16", "Pastaza");
        PROVINCIAS_ECUADOR.put("17", "Pichincha");
        PROVINCIAS_ECUADOR.put("18", "Tungurahua");
        PROVINCIAS_ECUADOR.put("19", "Zamora Chinchipe");
        PROVINCIAS_ECUADOR.put("20", "Galápagos");
        PROVINCIAS_ECUADOR.put("21", "Sucumbíos");
        PROVINCIAS_ECUADOR.put("22", "Orellana");
        PROVINCIAS_ECUADOR.put("23", "Santo Domingo");
        PROVINCIAS_ECUADOR.put("24", "Santa Elena");
        PROVINCIAS_ECUADOR.put("30", "Extranjero (Consulado)");
    }

    public static boolean esValida(String cedula) {
        // Verifica que no sea nula, que tenga 10 caracteres y que sean solo números
        if (cedula == null || !cedula.matches("\\d{10}")) {
            return false;
        }

        String provincia = cedula.substring(0, 2);
        if (!PROVINCIAS_ECUADOR.containsKey(provincia)) {
            return false;
        }

        int tercerDigito = Character.getNumericValue(cedula.charAt(2));
        if (tercerDigito < 0 || tercerDigito > 5) {
            return false;
        }

        int[] coeficientes = {2, 1, 2, 1, 2, 1, 2, 1, 2};
        int suma = 0;

        for (int i = 0; i < 9; i++) {
            int valor = Character.getNumericValue(cedula.charAt(i)) * coeficientes[i];
            if (valor > 9) {
                valor -= 9;
            }
            suma += valor;
        }

        int digitoVerificadorEsperado = Character.getNumericValue(cedula.charAt(9));
        int decenaSuperior = (int) (Math.ceil(suma / 10.0) * 10);
        int digitoCalculado = decenaSuperior - suma;

        if (digitoCalculado == 10) {
            digitoCalculado = 0;
        }

        return digitoCalculado == digitoVerificadorEsperado;
    }

    // Método opcional por si necesitas obtener el nombre de la provincia en el backend
    public static String obtenerProvincia(String cedula) {
        if (cedula != null && cedula.length() >= 2) {
            return PROVINCIAS_ECUADOR.getOrDefault(cedula.substring(0, 2), "Desconocida");
        }
        return "Desconocida";
    }
}