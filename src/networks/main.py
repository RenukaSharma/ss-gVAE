from .mnist_LeNet_vae import MNIST_LeNet, MNIST_LeNet_Autoencoder, MNIST_LeNet_Decoder
from .fmnist_LeNet_vae import FashionMNIST_LeNet, FashionMNIST_LeNet_Autoencoder, FashionMNIST_LeNet_Decoder
from .cifar10_LeNet_vae import CIFAR10_LeNet, CIFAR10_LeNet_Autoencoder, CIFAR10_LeNet_Decoder
from .mvtec_net_convdeconv import MVTec_net_Autoencoder
from .malaria_net import Malaria_net_Ext


def build_network(net_name, ae_net=None):
    """Builds the neural network."""

    implemented_networks = ('mnist_LeNet', 'fmnist_LeNet', 'cifar10_LeNet',
                            'mvtec_net', 'malaria_net')
    assert net_name in implemented_networks

    net = None
    dec_net = None

    if net_name == 'mnist_LeNet':
        net = MNIST_LeNet()
        dec_net = MNIST_LeNet_Decoder()

    if net_name == 'fmnist_LeNet':
        net = FashionMNIST_LeNet()
        dec_net = FashionMNIST_LeNet_Decoder()

    if net_name == 'cifar10_LeNet':
        net = CIFAR10_LeNet()
        dec_net = CIFAR10_LeNet_Decoder()

    if net_name == 'malaria_net':
        net = Malaria_net_Ext()

    return net, dec_net


def build_autoencoder(net_name):
    """Builds the corresponding autoencoder network."""

    implemented_networks = ('mnist_LeNet', 'fmnist_LeNet', 'cifar10_LeNet',
                            'mvtec_net', 'malaria_net')
    assert net_name in implemented_networks

    ae_net = None

    if net_name == 'mnist_LeNet':
        ae_net = MNIST_LeNet_Autoencoder()

    if net_name == 'fmnist_LeNet':
        ae_net = FashionMNIST_LeNet_Autoencoder()

    if net_name == 'cifar10_LeNet':
        ae_net = CIFAR10_LeNet_Autoencoder()

    if net_name == 'mvtec_net':
        ae_net = MVTec_net_Autoencoder()

    if net_name == 'malaria_net':
        ae_net = Malaria_net_Ext()

    return ae_net
