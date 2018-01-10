class MockProfilePolicy < ProjectRelatedPolicy
  def edit?
    show?
  end
end
