from .mnist_LeNet_vae import MNIST_LeNet, MNIST_LeNet_Autoencoder, MNIST_LeNet_Decoder
from .fmnist_LeNet import FashionMNIST_LeNet, FashionMNIST_LeNet_Autoencoder, FashionMNIST_LeNet_Decoder
from .cifar10_LeNet_vae import CIFAR10_LeNet
from .malaria_net import Malaria_net_Ext
from .binary_classifier_net import BinaryClassifierNet


def build_autoencoder(net_name):
    """Builds the corresponding autoencoder network used by the binary-classifier baseline."""

    implemented_networks = ('mnist_LeNet', 'fmnist_LeNet', 'cifar10_LeNet', 'malaria_net',
                            'cifar10_classifier', 'mnist_classifier', 'fmnist_classifier')
    assert net_name in implemented_networks

    ae_net = None

    if "classifier" in net_name:
        ae_net = BinaryClassifierNet(net_name)

    if net_name == 'mnist_LeNet':
        ae_net = MNIST_LeNet_Autoencoder()

    if net_name == 'fmnist_LeNet':
        ae_net = FashionMNIST_LeNet_Autoencoder()

    if net_name == 'cifar10_LeNet':
        ae_net = CIFAR10_LeNet()

    if net_name == 'malaria_net':
        ae_net = Malaria_net_Ext()

    return ae_net
