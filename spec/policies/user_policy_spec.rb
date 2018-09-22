# frozen_string_literal: true

describe UserPolicy do
  subject { UserPolicy }

  let (:current_user) { FactoryBot.build_stubbed :user }
  let (:other_user) { FactoryBot.build_stubbed :user }
  let (:admin) { FactoryBot.build_stubbed :user, :admin }

  permissions :index? do
    it 'prevents access if not an admin' do
      expect(UserPolicy).not_to permit(current_user)
    end
    it 'allows access for an admin' do
      expect(UserPolicy).to permit(admin)
    end
  end

  permissions :show? do
    it 'other users can see your profile' do
      expect(subject).to permit(current_user, other_user)
    end
    it 'allows you to see your own profile' do
      expect(subject).to permit(current_user, current_user)
    end
    it 'allows an admin to see any profile' do
      expect(subject).to permit(admin)
    end
  end

  permissions :update? do
    it 'prevents other users updating profile' do
      expect(subject).not_to permit(current_user, other_user)
    end

    it 'allows updates of your own profile' do
      expect(subject).to permit(current_user, current_user)
    end

    it 'allows an admin to make updates' do
      expect(subject).to permit(admin)
    end
  end

  permissions :destroy? do
    it 'prevents deleting yourself' do
      expect(subject).not_to permit(current_user, current_user)
    end
    it 'allows an admin to delete any users' do
      expect(subject).to permit(admin, other_user)
    end
  end
end
