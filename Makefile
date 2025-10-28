dependency:
	helm dependency update charts/$(c)

template:
	helm template $(c) charts/$(c) --output-dir out
