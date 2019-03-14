package com.erikriosetiawan;

import javax.swing.JOptionPane;

public class Main {

    public static void main(String[] args) {
        String nama;
        String makananfavoritPertama;
        String makananfavoritKedua;
        String result;
        nama = JOptionPane.showInputDialog(null, "Masukkan Nama Anda", "Input Nama", JOptionPane.QUESTION_MESSAGE);
        makananfavoritPertama = JOptionPane.showInputDialog(null,"Masukkan Makanan Favorit Pertama", "Makanan Favorit", JOptionPane.QUESTION_MESSAGE);
        makananfavoritKedua = JOptionPane.showInputDialog(null, "Masukkan Makanan Favorit Kedua", "Makanan Favotit", JOptionPane.QUESTION_MESSAGE);
        result = "Halo " + nama + ", Makanan Favorit Kamu Adalah " + makananfavoritPertama + " dan " + makananfavoritKedua;
        JOptionPane.showMessageDialog(null, result, "Hasil", JOptionPane.INFORMATION_MESSAGE );
    }
}
