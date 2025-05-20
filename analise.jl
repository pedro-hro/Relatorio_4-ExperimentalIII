using Plots
using Printf

# Constantes e dados experimentais
l_sf38 = 0.042
g=9.81

correnteParte1 = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
massaParte1 = [165.55, 165.75, 165.95, 166.11, 166.31, 166.5, 166.71, 166.92, 167.1, 167.29]
massa0Parte1 = 165.34

comprimentosParte2 = [0.012, 0.022, 0.032, 0.042, 0.064, 0.084]
massaParte2 = [165.56, 165.74, 165.93, 166.11, 166.54, 166.88]
massa0Parte2 = 165.36
correnteParte2 = 2.0

angulosParte3 = [0, 5, 11, 17, 23, 30, 37, 45, 54, 65, 90]
massaParte3 = [70.6, 70.59, 70.58, 70.56, 70.55, 70.54, 70.49, 70.43, 70.37, 70.29, 70.03]
massa0Parte3 = 70.07
correnteParte3 = 1.0

# Funções básicas
function calcular_forca(massa, massa0)
	delta_m = massa .- massa0
	delta_m_kg = delta_m ./ 1000
	forca = delta_m_kg .* g
	return forca
end

function calcular_B(massa, l0, massa0, corrente)
	forca = calcular_forca(massa, massa0)
	B = forca ./ (corrente .* l0)
	return B
end


# Análise dos dados
function analisar_parte1()
	println("== Análise da Parte I - Força versus Corrente Elétrica ==")
	delta_m = massaParte1 .- massa0Parte1
	println("Δm (g) = $delta_m")

	forca = calcular_forca(massaParte1, massa0Parte1)
	println("Força (N) = $forca")

	B = calcular_B(massaParte1, l_sf38, massa0Parte1, correnteParte1)
	println("Campo Magnético (T) = $B")

	p1 = scatter(correnteParte1, forca,
		label = "Dados experimentais",
		xlabel = "Corrente (A)",
		ylabel = "Força (N)",
		title = "Força Magnética vs. Corrente Elétrica - Parte I",
		marker = :circle,
		markersize = 6,
		legend = :topleft)
	display(p1)
	savefig(p1, "parte1_forca_vs_corrente.png")

	return B, forca, p1
end

function analisar_parte2()
	println("== Análise da Parte II - Força versus Comprimento ==")

	delta_m = massaParte2 .- massa0Parte2
	println("Δm (g) = $delta_m")

	forca = calcular_forca(massaParte2, massa0Parte2)
	println("Força (N) = $forca")

	B = calcular_B(massaParte2, comprimentosParte2, massa0Parte2, correnteParte2)
	println("Campo Magnético (T) = $B")

	p2 = scatter(comprimentosParte2, forca,
		label = "Dados experimentais",
		xlabel = "Comprimento (m)",
		ylabel = "Força (N)",
		title = "Força Magnética vs. Comprimento - Parte II",
		marker = :circle,
		markersize = 6,
		legend = :topleft)
	display(p2)
	savefig(p2, "parte2_forca_vs_comprimento.png")

	return B, forca, p2
end

function analisar_parte3()
	println("== Análise da Parte III - Força versus Ângulo ==")

	delta_m = massaParte3 .- massa0Parte3
	println("Δm (g) = $delta_m")

	forca = calcular_forca(massaParte3, massa0Parte3)
	println("Força (N) = $forca")

	sintheta = sind.(angulosParte3)
	println("sin(θ) = $sintheta")

	p3 = scatter(sintheta, forca,
		label = "Dados experimentais",
		xlabel = "Seno(θ)",
		ylabel = "Força (N)",
		title = "Força Magnética vs. Seno do Ângulo - Parte III",
		marker = :circle,
		markersize = 6,
		legend = :bottomleft)
	display(p3)
	savefig(p3, "parte3_forca_vs_angulo.png")

	return forca, p3
end

B1, forca1, p1 = analisar_parte1()
B2, forca2, p2 = analisar_parte2()
forca3, p3 = analisar_parte3()

# Gerar tabelas em LaTeX
function generate_latex_tables()
	delta_m_p1 = massaParte1 .- massa0Parte1
	delta_m_p2 = massaParte2 .- massa0Parte2
	delta_m_p3 = massaParte3 .- massa0Parte3
	sintheta = sind.(angulosParte3)

	latex_table_p1 = """
\\begin{tabular}{ccccc}
\\toprule
\$i\$ (A) & \$m\$ (g) & \$\\Delta m\$ (g) & \$F\$ (N) & \$B\$ (T) \\\\
\\midrule
"""
	for i in 1:length(correnteParte1)
		row = @sprintf(
			"%.1f & %.2f & %.2f & %.2e & %.2e \\\\\n",
			correnteParte1[i],
			massaParte1[i],
			delta_m_p1[i],
			forca1[i],
			B1[i]
		)
		latex_table_p1 *= row
	end
	latex_table_p1 *= "\\bottomrule\n\\end{tabular}"
	open("parte1_table.tex", "w") do f
		;
		write(f, latex_table_p1);
	end


	latex_table_p2 = """
\\begin{tabular}{ccccc}
\\toprule
\$l\$ (cm) & \$m\$ (g) & \$\\Delta m\$ (g) & \$F\$ (N) & \$B\$ (T) \\\\
\\midrule
"""
	l_cm = comprimentosParte2 .* 100
	for i in 1:length(l_cm)
		row = @sprintf(
			"%.1f & %.2f & %.2f & %.2e & %.2e \\\\\n",
			l_cm[i],
			massaParte2[i],
			delta_m_p2[i],
			forca2[i],
			B2[i]
		)
		latex_table_p2 *= row
	end
	latex_table_p2 *= "\\bottomrule\n\\end{tabular}"
	open("parte2_table.tex", "w") do f
		;
		write(f, latex_table_p2);
	end


	latex_table_p3 = """
\\begin{tabular}{ccccc}
\\toprule
\$\\theta\$ (°) & \$\\sin(\\theta)\$ & \$m\$ (g) & \$\\Delta m\$ (g) & \$F\$ (N) \\\\
\\midrule
"""
	for i in 1:length(angulosParte3)
		row = @sprintf(
			"%d & %.3f & %.2f & %+.2f & %.2e \\\\\n",
			angulosParte3[i],
			sintheta[i],
			massaParte3[i],
			delta_m_p3[i],
			forca3[i]
		)
		latex_table_p3 *= row
	end
	latex_table_p3 *= "\\bottomrule\n\\end{tabular}"
	open("parte3_table.tex", "w") do f
		;
		write(f, latex_table_p3);
	end
end

generate_latex_tables()
