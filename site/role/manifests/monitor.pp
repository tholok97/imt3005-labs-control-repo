# monitor is set up with jenkins, but jenkins should have it's own machine :/
class role::monitor {
    include ::profile::base_linux
    include ::profile::jenkins
}
