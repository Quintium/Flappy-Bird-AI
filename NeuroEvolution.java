import java.util.Arrays;

public class NeuroEvolution {
    NeuralNetwork[] nns;
    int population;

    public NeuroEvolution(int inputs, int hiddens, int outputs, int layers, int population_, double learningRate, double frequency, String activation) {
        population = population_;

        nns = new NeuralNetwork[population];
        for (int i = 0; i < population; i++) {
            nns[i] = new NeuralNetwork(inputs, hiddens, outputs, layers);
            nns[i].learningRate = learningRate;
            nns[i].frequency = frequency;
            nns[i].activation = activation;
        }
    }

    public void evolution(double[] scores) {
        // pass the best into the next generation and mutate them
        NeuralNetwork[] new_nns = new NeuralNetwork[population];
        double sum = Arrays.stream(scores).sum();
        double subtotal;

        for (int i = 0; i < population - 1; i++) {
            subtotal = Math.random() * sum;

            for (int j = 0; j < population; j++) {
                subtotal -= scores[j];
                if (subtotal < 0) {
                    new_nns[i] = nns[j].copy();
                    new_nns[i].mutate();
                    break;
                }
            }
        }

        // copy best nn
        int highest = 0;
        for (int i = 0; i < population; i++) {
            if (scores[i] > scores[highest]) {
                highest = i;
            }
        }

        new_nns[population - 1] = nns[highest].copy();

        nns = new_nns;
    }
}
