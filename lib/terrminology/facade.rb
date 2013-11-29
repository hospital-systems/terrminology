module Terrminology
  class Facade
    def u
      Utils
    end

    attr_reader :db

    def initialize(db)
      @db = db
    end

    def value_set_repository
      ValueSetRepository.new(db)
    end

    private :value_set_repository

    def value_sets
      value_set_repository.all
    end

    def create_value_set(attrs)
      value_set_attributes = u.normalize_attributes(attrs)

      value_set_attributes.delete('resource_type')
      value_set_attributes.delete('text')
      value_set_attributes.delete('telecom')
      define = value_set_attributes.delete('define')

      value_set_repository.create(value_set_attributes).tap do |vs|
        define['value_set_id'] = vs.identity
        concepts = define.delete('concept')
        df = define_repository.create(define)

        concepts = concepts.map do |concept|
          concept_repository.create(concept.merge(define_id: df.identity))
        end
      end
    end

    def find_valueset(id_or_identifier)
      value_set_repository.find(id_or_identifier)
    end

    def clear_value_sets!
      value_set_repository.destroy_all
    end

    def define_repository
      DefineRepository.new(db)
    end

    private :define_repository

    def defines
      define_repository.all
    end

    def create_define(define_attributes)
      define_repository.create(define_attributes)
    end

    def clear_defines!
      define_repository.destroy_all
    end

    def concept_repository
      ConceptRepository.new(db)
    end

    private :concept_repository

    def concepts(id_or_identifier)
      concept_repository.search(id_or_identifier)
    end

    def create_concept(concept_attributes)
      concept_repository.create(concept_attributes)
    end

    def clear_concepts!
      concept_repository.destroy_all
    end

    #def user_repository
    #  UserRepository.new(db)
    #end
    #
    #private :user_repository
    #
    #def users(query = {})
    #  user_repository.all
    #end
    #
    #def create_user(user_attributes)
    #  user_repository.create(user_attributes)
    #end
    #
    #def clear_users!
    #  user_repository.destroy_all
    #end
    #
    #def permission_repository
    #  PermissionRepository.new(db)
    #end
    #
    #private :permission_repository
    #
    #def create_permission(code, display_name)
    #  permission_repository.create(code: code.to_s, display_name: display_name)
    #end
    #
    #def permissions(query={})
    #  permission_repository.all
    #end
    #
    #def role_repository
    #  RoleRepository.new(db)
    #end
    #
    #def roles(query={})
    #  role_repository.all
    #end
    #
    #def create_role(display_name, description = nil)
    #  role_repository.create(display_name: display_name,
    #                         description: description)
    #end
    #
    #def role_permissions(role_id, fileter={})
    #  permission_repository.role_permissions(role_id, fileter)
    #end
    #
    #def grant_permission(role_id, permission_id)
    #  role_repository.associate_permission(role_id, permission_id)
    #end
    #
    #def assign_role(user_id, role_id)
    #  user_repository.assign_role(user_id, role_id)
    #end
    #
    #def user_roles(user_id, fileter = {})
    #  role_repository.user_roles(user_id, fileter)
    #end
    #
    #def allowed?(user_id, permission_name_or_id)
    #  user_repository.has_permission?(user_id, permission_name_or_id)
    #end
  end
end
