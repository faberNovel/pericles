require 'test_helper'

class ProxyConfigurationTest < ActiveSupport::TestCase
  test 'must have proxy_hostname and proxy_password or nothing' do
    assert_not build(:proxy_configuration, proxy_hostname: 'example.com').valid?
    assert_not build(:proxy_configuration, proxy_port: 1234).valid?
    assert build(:proxy_configuration, proxy_hostname: 'example.com', proxy_port: 1234).valid?
    assert build(:proxy_configuration, proxy_hostname: nil, proxy_port: nil).valid?
  end

  test 'must have password if proxy_username is set' do
    assert_not build(:proxy_configuration,
      proxy_hostname: 'example.com',
      proxy_port: 1234,
      proxy_username: 'user'
    ).valid?
    assert build(:proxy_configuration,
      proxy_hostname: 'example.com',
      proxy_port: 1234,
      proxy_username: 'user',
      proxy_password: '123'
    ).valid?
  end

  test 'cannot have proxy_username without proxy_hostname' do
    assert_not build(:proxy_configuration,
      proxy_hostname: nil,
      proxy_port: nil,
      proxy_username: 'user',
      proxy_password: '123'
    ).valid?
  end

  test 'use_http_proxy? returns true if proxy_hostname is set' do
    assert_not build(:proxy_configuration, proxy_hostname: nil, proxy_port: nil).use_http_proxy?
    assert build(:proxy_configuration, proxy_hostname: 'example.com', proxy_port: 1234).use_http_proxy?
  end

  test 'http_proxy_fields returns proxy_* fields' do
    conf = build(:proxy_configuration, proxy_hostname: 'example.com', proxy_port: 1234)
    assert_equal ['example.com', 1234], conf.http_proxy_fields

    conf.update(proxy_username: 'user', proxy_password: 'pass')
    assert_equal ['example.com', 1234, 'user', 'pass'], conf.http_proxy_fields
  end
end
