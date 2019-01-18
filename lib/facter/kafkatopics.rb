require 'open3'
Facter.add(:kafkatopics) do
  setcode do
    topic_array = []
    zoo_list = []
    if File.exists? "${bin_dir}/kafka-topics.sh"
      zoo = File.open("${config_dir}/server.properties")
        zoo.each_line do |r|
          r = r.partition('zookeeper.connect=')[2]
          r.chomp!
          zoo_list.push(r)
        end
    zoo_list.delete("")
      topiclist = Open3.popen3("${bin_dir}/kafka-topics.sh --list --zookeeper #{zoo_list[0]}")  { |stdin, stdout, stderr, wait_thr| stdout.read }
        topiclist.each_line do | line|
          line.chomp!
          topic_array.push(line)
        end
    end
    topic_array
  end
end
