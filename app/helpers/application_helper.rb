require "erb"

module ApplicationHelper
  FEDORA_BASE_URL = Rails.application.config.fcrepo_base_url
  IIIF_MANIFEST_PREFIX = Rails.application.config.iiif_manifest_url
  PCDM_OBJECT = 'pcdm:Object'
  PCDM_FILE = 'pcdm:File'
  ALLOWED_MIME_TYPE = 'image/tiff'

  def is_mirador_displayable(document)
    rdf_types = document._source[:rdf_type];
    if rdf_types.include? PCDM_OBJECT
      return true
    elsif document._source[:rdf_type].include? PCDM_FILE and (ALLOWED_MIME_TYPE == document._source[:mime_type])
      return true
    else
      return false
    end
  end

  def encoded_id(document)
    id = document._source[:id]
    id.slice!(FEDORA_BASE_URL)
    return ERB::Util.url_encode(id)
  end

  def iiif_base_url()
    return IIIF_MANIFEST_PREFIX
  end

  def from_subquery(subquery_field, args)
    args[:document][args[:field]] = args[:document][subquery_field]['docs']
  end

  def collection_from_subquery(args)
    from_subquery 'pcdm_collection_info', args
  end

  def parent_from_subquery(args)
    from_subquery 'pcdm_member_of_info', args
  end

  def members_from_subquery(args)
    from_subquery 'pcdm_members_info', args
  end

  def related_objects_from_subquery(args)
    from_subquery 'pcdm_related_objects_info', args
  end

  def related_object_of_from_subquery(args)
    from_subquery 'pcdm_related_object_of_info', args
  end

  def rdf_type_list(args)
    args[:document][args[:field]]
  end

  def fcrepo_url
    FEDORA_BASE_URL.sub(/fcrepo\/rest\/?/, "")
  end
end
