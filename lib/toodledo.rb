# -*- coding: utf-8 -*-
#  Toodledo
#
class Toodledo
  include HTTParty

  TOODLEDO_BASE = 'http://api.toodledo.com/2'
  TOODLEDO_TOKEN_URL = TOODLEDO_BASE + '/account/token.php'
  TOODLEDO_FOLDERS_URL = TOODLEDO_BASE + '/folders/add.php'
  TOODLEDO_TASKS_URL = TOODLEDO_BASE + '/tasks/add.php'

  def self.add_tasks(key, tasks_to_export)
    full_response = ''

    tasks_to_export.in_groups_of(20).each do |group|
      group.compact.each_with_index do |task, idx|
        parameterized_tasks += ',' unless idx == 0
        parameterized_tasks += task.to_json
      end
      parameterized_tasks = "[#{parameterized_tasks}]"
      full_response += HTTParty.post(
        'http://api.toodledo.com/2/tasks/add.php',
        query: { key: key, tasks: parameterized_tasks })
    end

    full_response
  end

  def self.session_token
    '51975db9d0c9a' if Rails.env.development?

    response = HTTParty.get('http://api.toodledo.com/2/account/token.php',
                            query: { userid: ENV['TOODLEDO_USER_ID'],
                                     appid: ENV['TOODLEDO_APP_ID'],
                                     sig: md5_signature })

    Rails.logger.debug('[toodledo::session_token] response = #{response.body}')
    JSON.parse(response.body)['token']
  end

  def self.add_folder(key, name)
    response = HTTParty.get('http://api.toodledo.com/2/folders/add.php',
                            query: {
                              name: name + "_#{Time.now.to_i % 10}",
                              key: key }
                           )
    Rails.logger.debug('[toodledo::add_folder]' + response.body)

    JSON.parse(response.body).first['id']
  end

  def self.key=(session_token)
    hashed_password = Digest::MD5.hexdigest(ENV['TOODLEDO_PASSWORD'])
    Digest::MD5.hexdigest(hashed_password +
                          ENV['TOODLEDO_APP_TOKEN'] +
                          session_token)
  end

  def self.md5_signature
    Digest::MD5.hexdigest(ENV['TOODLEDO_USER_ID'] + ENV['TOODLEDO_APP_TOKEN'])
  end
end
