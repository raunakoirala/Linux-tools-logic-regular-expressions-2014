

# This function generates the CNF clauses for the vertex-coloring constraints
function generate_vertex_color_constraints(num_vertices) {
    for (i = 1; i <= num_vertices; i++) {
        printf("(%s | %s | %s) & (~%s | ~%s | ~%s)", var(i, "Red"), var(i, "White"), var(i, "Black"), var(i, "Red"), var(i, "White"), var(i, "Black"));
        if (i != num_vertices) {
            printf(" & ");
        }
    }
}

# This function generates the CNF clauses for the adjacent vertices having different colors
function generate_adjacent_color_constraints(graph_edges) {
    first_edge = 1;
    for (edge in graph_edges) {
        if (!first_edge) {
            printf(" & ");
        }
        first_edge = 0;

        # Split edge information to get vertices
        split(edge, vertices, "--");
        i = vertices[1];
        j = vertices[2];

        # Generate clauses ensuring that adjacent vertices have different colors
        printf("(~%s | ~%s)", var(i, "Red"), var(j, "Red"));
        printf(" & ");
        printf("(~%s | ~%s)", var(i, "White"), var(j, "White"));
        printf(" & ");
        printf("(~%s | ~%s)", var(i, "Black"), var(j, "Black"));
    }
}

# Function to generate the variable name
function var(vertex, color) {
    return "v" vertex color;
}

BEGIN {
    num_vertices = 0;
}

# Read input edges and vertices
NR == 1 {
    num_vertices = $1;
}

NR > 1 {
    graph_edges[$1 "--" $3] = 1;
}

END {

    # At the end of processing input, generate the CNF clauses for vertex-coloring constraints.
    printf("sage -c 'print(propcalc.formula(\"");
    generate_vertex_color_constraints(num_vertices);

    # Check if there are vertices and edges to generate adjacent color constraints.
    if (num_vertices > 0 && length(graph_edges) > 0) {
        printf(" & ");
    }

    # Generate CNF clauses for the adjacent vertices having different colors.
    generate_adjacent_color_constraints(graph_edges);

    # Print a newline character to finish the CNF expression.
    printf("\").is_satisfiable())'\n");
}

