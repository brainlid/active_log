module ParolkarInnovationLab
  module SocialNet
    def self.included(base)
      base.extend ParolkarInnovationLab::SocialNet::ClassMethods
    end

    module ClassMethods
      # Specify this model as having changes tracked and recorded. Changes are written to an ActiveLog model
      # and accessible through "active_logs" associations on this model. The associated user (if any) may
      # be associated with the changes as well. 
      def records_active_log(arg_hash={})
        include ParolkarInnovationLab::SocialNet::InstanceMethods
        # Before the save is performed, grab what is changed.
        before_save :record_changes_for_active_log
        # After the save is done, write it to the ActiveLog
        after_save :save_active_log

        # Add the link to the change log on the model automatically. 
        has_many :active_logs, :as => :ar
      end
    end

    module InstanceMethods
      private
        # Grab a copy of the of the changes about to be saved.
        def record_changes_for_active_log
          @was_just_created = new_record?
          @copy_of_changes = changes
        end
        # Save the information on the changes to the log.
        def save_active_log
          # If there are changes to store, create the log entry. If the user opens a model and "saves",
          # don't store an empty change log entry.
          if !changes.empty?
            log = ActiveLog.new
            log.ar = self
            # Track the type of change (create vs update)
            log.was_created = @was_just_created
            log.changed_content = @copy_of_changes
            log.user_id = ActiveLog.current.id if ActiveLog.current # How does this work? Well.. You gotta put a before_filter in application controller which assigns ActiveLog.current = current_user
            log.save!
          end
        end
    end
  end
 end  

